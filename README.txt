The protein_projector applet contained within this directory houses the ProteinProjector code implemented in https://github.com/idekerlab/cellmaps_coembedding

A description of the algorithm can be found in this publication:

Leah V Schaffer, Mayank Jain, Rami Nasser, Roded Sharan, Trey Ideker, Unifying proteomic technologies with ProteinProjector, Bioinformatics Advances, Volume 5, Issue 1, 2025, vbaf266, https://doi.org/10.1093/bioadv/vbaf266

The files embed_1.tsv and embed_2.tsv can be used as an example input to this applet. The output is a gzipped tarfile containing a Research Object Crate (RO-Crate) which is basically a folder with meta data and the embeddding stored in the file co_embedding.tsv. For more information about the output structure visit:

https://cellmaps-coembedding.readthedocs.io

The file proteinprojector_results.tar.gz is an example output from a run using the embed_1.tsv & embed_2.tsv files.


 
