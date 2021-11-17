#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define BWRAID_VOLUME_MIN_SIZE (1ULL << 30)
#define SPDK_EXTENTS_PER_EP 512
#define BWRAID_EXTENT_ENTRY_PER_PAGE (4072 / sizeof(uint32_t))
#define SPDK_BS_PAGE_SIZE 0x1000

static inline uint64_t
spdk_divide_round_up(uint64_t num, uint64_t divisor)
{
	return (num + divisor - 1) / divisor;
}

struct spdk_bs_md_mask {
	uint8_t		type;
	uint32_t	length; /* In bits */
	uint8_t		mask[0];
};

static inline uint64_t
bs_page_to_lba(uint64_t blocklen, uint64_t page)
{
	return page * SPDK_BS_PAGE_SIZE / blocklen;
}


int main(int argc, char *argv[]) {

    if (argc != 4) {
        return -1;
    }

    uint64_t blockcnt = atoi(argv[1]);
    uint64_t blocklen = atoi(argv[2]);
    uint64_t cluster_sz = atoi(argv[3]);

    uint64_t cluster_num;
    uint32_t volume_cnt, extent_page_num, md_page_num;

    cluster_num = blockcnt * blocklen / cluster_sz;
    volume_cnt = 2 * blockcnt * blocklen / BWRAID_VOLUME_MIN_SIZE;
    extent_page_num = spdk_divide_round_up(cluster_num, SPDK_EXTENTS_PER_EP);
    md_page_num = 2 * volume_cnt + spdk_divide_round_up(extent_page_num, BWRAID_EXTENT_ENTRY_PER_PAGE);

    uint32_t md_len =  md_page_num + extent_page_num;
    uint64_t num_md_pages = 1;

    num_md_pages += spdk_divide_round_up(sizeof(struct spdk_bs_md_mask) +
					 spdk_divide_round_up(md_len, 8),
					 SPDK_BS_PAGE_SIZE);
    num_md_pages += spdk_divide_round_up(sizeof(struct spdk_bs_md_mask) +
					    spdk_divide_round_up(cluster_num, 8),
					    SPDK_BS_PAGE_SIZE);
    num_md_pages += spdk_divide_round_up(sizeof(struct spdk_bs_md_mask) +
					   spdk_divide_round_up(md_len, 8),
					   SPDK_BS_PAGE_SIZE);
    num_md_pages += md_len;

    uint64_t num_md_bytes = num_md_pages * SPDK_BS_PAGE_SIZE;

    printf("%lu", num_md_bytes);

    return 0;
}