<!-- dx-header -->

# Protein Projector (DNAnexus Platform App)

ProteinProjector is a self-supervised deep learning framework that flexibly integrates all available protein data across any number of modalities, producing a unified map of protein position.

<!-- /dx-header -->

ProteinProjector takes two or more embedding files in TSV format:

```bash
gene    <COL ID1>   <COL ID2> ...
<GENE1> <VALUE1>   <VALUE2> ...
```

**Example:**

```bash
gene    1   2   3   4   5
G1  0.1 0.2 0.3 0.4 0.5
G2  0.1 0.2 0.3 0.4 0.5
G3  0.1 0.2 0.3 0.4 0.5
G4  0.1 0.2 0.3 0.4 0.5
```

**NOTE:** All embedding files must have the same dimension.

The implementation of ProteinProjector is part of the Cell Mapping Toolkit Coembedding tool. For
more information visit: https://github.com/idekerlab/cellmaps_coembedding

To cite:

Leah V Schaffer, Mayank Jain, Rami Nasser, Roded Sharan, Trey Ideker, Unifying proteomic technologies with ProteinProjector, Bioinformatics Advances, Volume 5, Issue 1, 2025, vbaf266, https://doi.org/10.1093/bioadv/vbaf266
