#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @brief Print the usage information
 *
 */
void usage() {
    printf("Usage: ./csim -s <num> -E <num> -b <num> -t <file>\n");
    printf("Options:\n");
    printf("  -s <num>   Number of set index bits.\n");
    printf("  -E <num>   Number of lines per set.\n");
    printf("  -b <num>   Number of block offset bits.\n");
    printf("  -t <file>  Trace file.\n");
    printf("\n");
    printf("Examples:\n");
    printf("  linux>  ./csim -s 4 -E 1 -b 4 -t traces/yi.trace\n");
}

/**
 * @brief Parse the arguments. It will store them into *s, *E, *b, the file.
 *
 * @return int 0 means parsed successfully
 */
int parse_cmd(int args, char **argv, int *s, int *E, int *b, char *filename) {
    int flag[4] = {0};
    int flag_num = 4;

    for (int i = 0; i < args; i++) {
        char *str = argv[i];
        if (str[0] == '-') {
            if (str[1] == 's' && i < args) {
                i++;
                sscanf(argv[i], "%d", s);
                flag[0] = 1;
            } else if (str[1] == 'E' && i < args) {
                i++;
                sscanf(argv[i], "%d", E);
                flag[1] = 1;
            } else if (str[1] == 'b' && i < args) {
                i++;
                sscanf(argv[i], "%d", b);
                flag[2] = 1;
            } else if (str[1] == 't' && i < args) {
                i++;
                sscanf(argv[i], "%s", filename);
                flag[3] = 1;
            }
        }
    }
    for (int i = 0; i < flag_num; i++) {
        if (flag[i] == 0) {
            printf("./csim: Missing required command line argument\n");
            usage();
            return 1;
        }
    }
    return 0;
}

/**
 * @brief Print the final string.
 *
 */
void printSummary(int hits, int misses, int evictions) {
    printf("hits:%d misses:%d evictions:%d\n", hits, misses, evictions);
}

/**
 * @brief Read and parse one line from the file-ptr trace.
 *
 * @return int 0 for read and parsed successfully
 */
int readline(FILE *trace, char *op, unsigned long long *address, int *request_length) {
    char str[30];
    if (fgets(str, 30, trace) == NULL) {
        return -1;
    }
    sscanf(str, " %c %llx,%d", op, address, request_length);

    return 0;
}

#pragma region Structures-And-Functions

// [1/4] Your code for definition of structures, global variables or functions

#pragma endregion

typedef struct {
    int valid;
    unsigned long long tag;
    int counter;
}cache_line_t;


cache_line_t** cache;

int hit_count = 0;
int miss_count = 0;
int eviction_count = 0;
int lru_time = 0;

int main(int args, char **argv) {

#pragma region Parse
    int s, E, b;
    char filename[1024];
    if (parse_cmd(args, argv, &s, &E, &b, filename) != 0) {
        return 0;
    }
#pragma endregion

#pragma region Cache-Init

    // [2/4] Your code for initialzing your cache
    // You can use variables s, E and b directly.

    //--------------------------------------//
    // s: set_index位数                     //
    // E: E路组相联，每组E个cache块          //
    // b: 偏移位数                          //
    //-------------------------------------//

    //计算cache的组数
    int S = 1 << s;
    //为cache分配内存
    cache = (cache_line_t**) malloc(S * sizeof(cache_line_t*));

    for (int i = 0; i < S; i++) {
        cache[i] = (cache_line_t*) malloc(E*sizeof(cache_line_t));
        for (int j = 0; j < E; j++) {
            cache[i][j].valid = 0;
            cache[i][j].tag = 0;
            cache[i][j].counter = 0;
        }
    }


#pragma endregion

#pragma region Handle-Trace
    FILE *trace = fopen(filename, "r");
    char op;
    unsigned long long address;
    int request_length;

    while (readline(trace, &op, &address, &request_length) != -1) {
        // [3/4] Your code for handling the trace line
        if (op == 'I') {
            continue;
        }

        //计算索引于标签
        unsigned long long set_index = (address >> b) & ((1 << s) - 1);
        unsigned long long tag = address >> (s + b);

        //获取对应cache组
        cache_line_t* set = cache[set_index];

        //全局时间戳增加
        lru_time++;

        int hit = 0;                    //命中标识
        int empty_line = -1;            //记录空闲的cache行
        int lru_line = 0;               //记录最近最少使用的cache行
        int min_lru = lru_time;
        //遍历cache组中每一块判断是否命中
        for (int i = 0; i < E; i++) {
            if (set[i].valid == 1) {
                if (set[i].tag == tag) {
                    hit = 1;
                    set[i].counter = lru_time;
                    hit_count++;
                    break;
                }
                if (set[i].counter< min_lru) {
                    min_lru = set[i].counter;
                    lru_line = i;
                }
            } else {
                empty_line = i;
            }
        }

        if (!hit) {
            miss_count++;
            if (empty_line != -1) {
                set[empty_line].valid = 1;
                set[empty_line].tag = tag;
                set[empty_line].counter = lru_time;
            } else {
                eviction_count++;
                set[lru_line].tag = tag;
                set[lru_line].counter = lru_time;
            }
        }

        if (op == 'M') {
            hit_count++;
        }
    }

#pragma endregion

    // [4/4] Your code to output the hits, misses and evictions
    printSummary(hit_count, miss_count, eviction_count);

    // Maybe you can 'free' your cache here
    for (int i = 0; i < S; i++) {
        free(cache[i]);
    }
    free(cache);

    return 0;
}
