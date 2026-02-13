#!/usr/bin/env python

"""Generate a toy gene-by-feature DataFrame.

Creates a 100 x 1024 table with five example genes seeded from the user's
provided values and random data for the remainder. Adjust counts via CLI
flags.
"""

import argparse
from typing import List

import numpy as np
import pandas as pd


EXAMPLE_ROWS = {
    "HDAC2": [0.00322267, 0.068772331, 0.087871492, 0.074549779],
    "SMARCA4": [0.014913903, -0.025018152, -0.01334604, -0.050020121],
    "DNMT3A": [0.030166976, 0.082494646, 0.083659336, -0.005459526],
    "KDM6A": [0.058055822, 0.151974067, 0.122265264, 0.057505969],
    "RPS4X": [0.016731756, 0.046027087, 0.041698962, 0.010518731],
}


def build_gene_list(total_genes: int) -> List[str]:
    """Return a gene list starting with the example genes."""
    if total_genes < len(EXAMPLE_ROWS):
        raise ValueError(f"total_genes must be at least {len(EXAMPLE_ROWS)}")
    filler_needed = total_genes - len(EXAMPLE_ROWS)
    filler = [f"GENE_{i:03d}" for i in range(1, filler_needed + 1)]
    return list(EXAMPLE_ROWS.keys()) + filler


def generate_dataframe(total_genes: int, total_features: int, seed: int) -> pd.DataFrame:
    """Create the DataFrame with reproducible random values."""
    rng = np.random.default_rng(seed) if hasattr(np.random, "default_rng") else np.random.RandomState(seed)
    genes = build_gene_list(total_genes)
    data = rng.normal(loc=0.0, scale=0.1, size=(total_genes, total_features))
    df = pd.DataFrame(data, index=genes, columns=[str(i + 1) for i in range(total_features)])
    print(df.head())
    # Overwrite the first four columns for the example genes with provided values.
    for gene, values in EXAMPLE_ROWS.items():
        df.loc[gene, df.columns[:4]] = values

    df = df.reset_index().rename(columns={"index": "gene"})

    return df


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--genes", type=int, default=100, help="Number of gene rows.")
    parser.add_argument("--features", type=int, default=1024, help="Number of feature columns.")
    parser.add_argument("--seed", type=int, default=42, help="Random seed for reproducibility.")
    parser.add_argument(
        "--out",
        type=str,
        default=None,
        help="Optional path to save the DataFrame as TSV; prints head() if omitted.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    df = generate_dataframe(args.genes, args.features, args.seed)
    if args.out:
        df.to_csv(args.out, sep='\t', index=False, header=True)
        print(f"Wrote DataFrame with shape {df.shape} to {args.out}")
    else:
        print(df.head())  # quick visual check
        print(f"\nShape: {df.shape}")


if __name__ == "__main__":
    main()
