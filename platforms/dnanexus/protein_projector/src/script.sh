#!/bin/bash
#set -euo pipefail

main() {
    dx-download-all-inputs --parallel   # downloads into ~/in/<input_name>/... :contentReference[oaicite:3]{index=3}
    echo "input_embeddings old way: $input_embeddings"
    

    embedfiles=()
    for Y in `find "$HOME/in" -name "*.tsv" -type f`; do
       embedfiles+=("$Y")
    done
    
    mkdir -p "$HOME/out/"
    
    echo "Embedding list is: ${embedfiles[@]}"

    docker load -i /protein_projector.tar.gz
    # sets image to load
    image="digitaltumors/protein_projector:@@VERSION@@"

    # Run container, mounting DNAnexus in/out
    docker run --rm \
      -v "$HOME/in:$HOME/in:ro" \
      -v "$HOME/out:/out" \
      "$image" \
      -vvv \
        --embeddings "${embedfiles[@]}" \
        --algorithm "proteinprojector" \
        "/out/proteinprojector_results_tar" || true

    ecode=$?
    echo "Exit code is: $ecode"

    tar -czf "$HOME/out/proteinprojector_results.tar.gz" -C "$HOME/out/proteinprojector_results_tar" .

    dx upload "$HOME/out/proteinprojector_results.tar.gz" --brief > results_file_id.txt || true
    echo "file id: "
    cat results_file_id.txt || true

    dx-jobutil-add-output proteinprojector_results_tar "$(cat results_file_id.txt)" --class file
}

# main "$@"

