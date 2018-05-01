fswatch -o . | xargs -n1 -I{} ./bin/sync_rubyx.sh
