#!/bin/bash
set -euo pipefail

main() {
    dx-download-all-inputs --parallel   # downloads into ~/in/<input_name>/... :contentReference[oaicite:3]{index=3}

    pushd "$HOME/in/input_rocrate"
    mkdir -p "$HOME/out/"
    tar -zxf "${input_rocrate_path[0]}" -C "$HOME/out"
    echo "Prefix: ${input_rocrate_prefix[0]}"

    docker load -i /elasticnet_dre.tar.gz

    image="digitaltumors/elasticnet_dre:0.1.0"

    # Run container, mounting DNAnexus in/out
    docker run --rm \
      -v "$HOME/in:/in:ro" \
      -v "$HOME/out:/out" \
      "$image" \
      -vvv \
        --input_crate "/out/${input_rocrate_prefix[0]}" \
        --mode "$mode" \
        ${model:+--model /in/model} \
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

