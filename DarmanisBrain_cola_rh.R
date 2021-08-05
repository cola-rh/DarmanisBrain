setwd("/omics/groups/OE0246/internal/guz/cola_hc/examples/DarmanisBrain")
library(cola)

process_counts = function(data, column = NULL) {
    mat = assays(data)$counts
    mat = as.matrix(mat)
    s = colSums(mat)
    fa = s/mean(s)
    for(i in 1:ncol(mat)) mat[, i]/fa[i]
    mat = adjust_matrix(log2(mat + 1))

    anno = NULL
    if(!is.null(column)) {
        anno = colData(data)
           anno = as.data.frame(anno)
        anno = anno[, column, drop = FALSE]
    }

    list(mat = mat, anno = anno)
}

library(scRNAseq)
data = readRDS('/omics/groups/OE0246/internal/guz/cola_hc/examples/DarmanisBrain/DarmanisBrain_data.rds')
lt = process_counts(data, c("age", "cell.type"))
rh = hierarchical_partition(lt$mat, subset = 500, cores = 4, anno = lt$anno)
saveRDS(rh, file = "DarmanisBrain_cola_rh.rds")

cola_report(rh, output = "DarmanisBrain_cola_rh_report", title = "cola Report for Hierarchical Partitioning - 'DarmanisBrain'")
