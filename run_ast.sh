for filefolder in   "esc50" "speechcommands":
do
    cd  egs/$filefolder
    nohup bash run*.sh  2>&1 | tee  run_ast.log
done
