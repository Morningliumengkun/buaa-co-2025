#include "libcsim.h"
#include <limits.h>
#include <stdio.h>

static void print_answer(int answer) {
    printf("%d\n", answer);
}


int main() {
    struct cache_config_t config;
    usize address;
    init_cache(&config, FLUSH_RELOAD);

    //单个cache行的容量
    usize cache_line_size = 1 << config.block_bit;
    //cache组数
    usize group_num = 1 << config.index_bit;
    //cache行的数量
    usize cache_line_num = group_num * config.way_count;
    //整个cache的容量
    usize cache_size = cache_line_num * cache_line_size;

    //flush
    for (usize i = 0; i < group_num; i++) {
        for (usize j = 0; j < config.way_count; j++) {
            address = RELOAD_BASE + 256 * cache_line_size + i * cache_line_size + group_num * cache_line_size * j;
            access_addr(address);
        }
    }

    int answer = -1;

    for (usize i = 0;; i++) {
        preform_predict_access();
        for (usize j = 0; j < cache_line_num; j++) {
            address = RELOAD_BASE + j * cache_line_size + i * cache_size;
            int time = access_addr(address);
            if (time == TIME_HIT) {
                answer = j + i * cache_line_num;
                break;
            }
        }
        if (answer != -1) {
            break;
        }
        for (usize j = 0; j < group_num; j++) {
            for (usize k = 0; k < config.way_count; k++) {
                address = RELOAD_BASE + 256 * cache_line_size + j * cache_line_size + k * group_num * cache_line_size;
                access_addr(address);
            }
        }
    }

    print_answer(answer);


    return 0;
}
