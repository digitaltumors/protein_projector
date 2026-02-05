#!/bin/bash
set -euo pipefail

main() {
    dx-download-all-inputs --parallel   # downloads into ~/in/<input_name>/... :contentReference[oaicite:3]{index=3}


    embedfiles=()
    mkdir -p "$HOME/in/"
    pushd "$HOME/in/" 2>&1 >/dev/null
    for f in $(jq -r '.files[]["$dnanexus_link"]' "$embedding_list"); do
       name=$(dx describe "$f" --json | jq -r .name)
       dx download "$f" -o "$name"
       embedfiles+=("$name")
    done
    popd 2>&1 >/dev/null

    mkdir -p "$HOME/out/"
    embedding_list="${input_embeddings[*]}"
    echo "Embedding list is: $embedding_list"

    docker load -i /protein_projector.tar.gz
    # sets image to load
    image="digitaltumors/protein_projector:@@VERSION@@"

    # Run container, mounting DNAnexus in/out
    docker run --rm \
      -v "$HOME/in:/in:ro" \
      -v "$HOME/out:/out" \
      "$image" \
      -vvv \
        --embeddings "${embedfiles[@]}" \
        --algorithm "proteinprojector" \
        "/out/results_tar" || true

    ecode=$?
    echo "Exit code is: $ecode"

    tar -czf "$HOME/out/results.tar.gz" -C "$HOME/out/results_tar" .

    dx upload "$HOME/out/results.tar.gz" --brief > results_file_id.txt || true
    echo "file id: "
    cat results_file_id.txt || true

    dx-jobutil-add-output results_tar "$(cat results_file_id.txt)" --class file
}

# main "$@"

