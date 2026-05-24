#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <ctype.h>
#include <sys/sysinfo.h>
#include <time.h>

#define MAX_PROCESSES 512
#define COLOR_RESET   "\033[0m"
#define COLOR_BOLD   "\033[1m"
#define COLOR_GREEN  "\033[32m"
#define COLOR_YELLOW "\033[33m"
#define COLOR_RED    "\033[31m"
#define COLOR_CYAN   "\033[36m"
// This code was written by LLM models. 
// We are not responsible for damages
// Only CTRL+C works for exiting
struct proc_info {
    int pid;
    char comm[256];
    char state;
    long rss_kb;
    long vsz_kb;
    double cpu_usage;
};

struct cpu_stat {
    long user, nice, system, idle;
};

int proc_count = 0;
struct proc_info processes[MAX_PROCESSES];

void read_cpu_stat(struct cpu_stat *stat) {
    FILE *fp = fopen("/proc/stat", "r");
    if (!fp) return;
    
    fscanf(fp, "cpu %ld %ld %ld %ld", &stat->user, &stat->nice, &stat->system, &stat->idle);
    fclose(fp);
}

double calculate_cpu_percent(struct cpu_stat *old, struct cpu_stat *new) {
    long old_total = old->user + old->nice + old->system + old->idle;
    long new_total = new->user + new->nice + new->system + new->idle;
    
    long old_idle = old->idle;
    long new_idle = new->idle;
    
    long total_diff = new_total - old_total;
    long idle_diff = new_idle - old_idle;
    
    if (total_diff == 0) return 0.0;
    
    return ((total_diff - idle_diff) * 100.0) / total_diff;
}

void get_memory_info(long *total, long *available) {
    FILE *fp = fopen("/proc/meminfo", "r");
    if (!fp) return;
    
    char line[256];
    while (fgets(line, sizeof(line), fp)) {
        if (sscanf(line, "MemTotal: %ld", total) == 1) continue;
        if (sscanf(line, "MemAvailable: %ld", available) == 1) break;
    }
    fclose(fp);
}

double get_temperature() {
    FILE *fp = fopen("/sys/class/thermal/thermal_zone0/temp", "r");
    if (!fp) return -1.0;
    
    double temp;
    fscanf(fp, "%lf", &temp);
    fclose(fp);
    
    return temp / 1000.0;
}

void get_uptime(int *days, int *hours, int *minutes) {
    FILE *fp = fopen("/proc/uptime", "r");
    if (!fp) return;
    
    double uptime_sec;
    fscanf(fp, "%lf", &uptime_sec);
    fclose(fp);
    
    int total_seconds = (int)uptime_sec;
    *days = total_seconds / 86400;
    *hours = (total_seconds % 86400) / 3600;
    *minutes = (total_seconds % 3600) / 60;
}

void get_process_list() {
    DIR *dir = opendir("/proc");
    if (!dir) return;
    
    struct dirent *entry;
    proc_count = 0;
    
    while ((entry = readdir(dir)) && proc_count < MAX_PROCESSES) {
        if (!isdigit(entry->d_name[0])) continue;
        
        int pid = atoi(entry->d_name);
        char path[256];
        snprintf(path, sizeof(path), "/proc/%d/stat", pid);
        
        FILE *fp = fopen(path, "r");
        if (!fp) continue;
        
        struct proc_info *p = &processes[proc_count];
        p->pid = pid;
        
        char temp[256];
        fscanf(fp, "%d (%255[^)]) %c %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %ld %ld",
               &p->pid, temp, &p->state, &p->vsz_kb, &p->rss_kb);
        
        strcpy(p->comm, temp);
        p->rss_kb *= 4;
        p->vsz_kb /= 1024;
        p->cpu_usage = 0.0;
        
        proc_count++;
        fclose(fp);
    }
    closedir(dir);
}

int compare_ram(const void *a, const void *b) {
    return ((struct proc_info *)b)->rss_kb - ((struct proc_info *)a)->rss_kb;
}

int compare_pid(const void *a, const void *b) {
    return ((struct proc_info *)a)->pid - ((struct proc_info *)b)->pid;
}

void render_ui(double cpu_percent, long total_mem, long avail_mem, double temp, int days, int hours, int minutes) {
    system("clear");
    
    long used_mem = total_mem - avail_mem;
    int mem_percent = (used_mem * 100) / total_mem;
    int cpu_bar_len = (int)(cpu_percent / 5);
    int mem_bar_len = (mem_percent / 5);
    
    printf("%s┌─────────────────────────────────────────────────────────┐%s\n", COLOR_CYAN, COLOR_RESET);
    printf("%s│ UTOP - UnieOS System Monitor          Uptime: %dd %dh %dm %s│%s\n", 
           COLOR_BOLD, COLOR_CYAN, days, hours, minutes, COLOR_RESET, COLOR_CYAN);
    printf("%s├─────────────────────────────────────────────────────────┤%s\n", COLOR_CYAN, COLOR_RESET);
    
    printf("%s│%s CPU: ", COLOR_CYAN, COLOR_RESET);
    for (int i = 0; i < cpu_bar_len; i++) printf("▓");
    for (int i = cpu_bar_len; i < 20; i++) printf("░");
    printf(" %.1f%%  ", cpu_percent);
    
    printf("RAM: ");
    for (int i = 0; i < mem_bar_len; i++) printf("▓");
    for (int i = mem_bar_len; i < 20; i++) printf("░");
    printf(" %ld/%ld MB (%d%%)  %s│%s\n", used_mem/1024, total_mem/1024, mem_percent, COLOR_CYAN, COLOR_RESET);
    
    printf("%s│%s Temp: ", COLOR_CYAN, COLOR_RESET);
    if (temp >= 0) printf("%.1f°C", temp);
    else printf("N/A");
    printf("  Procs: %d", proc_count);
    
    for (int i = 0; i < 40 - (temp >= 0 ? 14 : 8); i++) printf(" ");
    printf("%s│%s\n", COLOR_CYAN, COLOR_RESET);
    
    printf("%s├──────────────────────────────────┬────────┬──────────────┤%s\n", COLOR_CYAN, COLOR_RESET);
    printf("%s│ PID    COMM                     │ RAM    │ VSIZ    STAT %s│%s\n", 
           COLOR_BOLD, COLOR_CYAN, COLOR_RESET);
    printf("%s├──────────────────────────────────┼────────┼──────────────┤%s\n", COLOR_CYAN, COLOR_RESET);
    
    qsort(processes, proc_count, sizeof(struct proc_info), compare_ram);
    
    for (int i = 0; i < (proc_count < 10 ? proc_count : 10); i++) {
        struct proc_info *p = &processes[i];
        
        char state_str[2] = {p->state, '\0'};
        long ram_mb = p->rss_kb / 1024;
        long vsz_mb = p->vsz_kb / 1024;
        
        printf("%s│%s %5d  %-31s │ %4ldMB │ %5ldMB  %s  %s│%s\n",
               COLOR_CYAN, COLOR_RESET, p->pid, 
               strlen(p->comm) > 31 ? p->comm : p->comm,
               ram_mb, vsz_mb, state_str, COLOR_CYAN, COLOR_RESET);
    }
    
    printf("%s├──────────────────────────────────┴────────┴──────────────┤%s\n", COLOR_CYAN, COLOR_RESET);
    printf("%s│ q:quit  s:sort  r:refresh  p:pid  m:memory               %s│%s\n", COLOR_CYAN, COLOR_RESET, COLOR_CYAN);
    printf("%s└─────────────────────────────────────────────────────────┘%s\n", COLOR_CYAN, COLOR_RESET);
}

int main(int argc, char *argv[]) {
    struct cpu_stat old_stat, new_stat;
    
    int batch_mode = 0;
    int iterations = -1;
    
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--batch") == 0) batch_mode = 1;
        if (strcmp(argv[i], "-n") == 0 && i+1 < argc) iterations = atoi(argv[i+1]);
    }
    
    int iter = 0;
    while (iterations < 0 || iter < iterations) {
        read_cpu_stat(&old_stat);
        sleep(1);
        read_cpu_stat(&new_stat);
        
        long total_mem, avail_mem;
        get_memory_info(&total_mem, &avail_mem);
        
        double cpu_percent = calculate_cpu_percent(&old_stat, &new_stat);
        double temp = get_temperature();
        
        int days, hours, minutes;
        get_uptime(&days, &hours, &minutes);
        
        get_process_list();
        
        if (!batch_mode) {
            render_ui(cpu_percent, total_mem, avail_mem, temp, days, hours, minutes);
        } else {
            printf("%.1f %ld %ld %.1f %d:%d:%d %d\n", 
                   cpu_percent, total_mem, avail_mem, temp, days, hours, minutes, proc_count);
        }
        
        iter++;
        if (iterations < 0) sleep(1);
    }
    
    return 0;
}

