# 覚え書き
- 簡単な回路から始めて拡張していく
    - キャッシュ・メモリ・分岐予測器等
    - RV32IMからRV32IMA, RV32IMAF, RV32IMAFD, RV32IMAFDCへと拡張
- 趣味のGitHubで公開しているプロジェクト

# メモ
- 考慮漏れを見つけ次第追記する

# TODOメモ
- 回路図の整理
- jamp命令実行時にpcレジスタが更新されるタイミングが適切か
- assertion記述の追加
- debug用の配線を追加
- if-else, case文でのdefault記述の追加
- ファイルの階層化
- TODOの実装
- csr命令
- 割り込み
- 例外
- MMU＆キャッシュ
- マルチプロセッサの実装
- タイマー

# パイプラインステージの流れ
- 命令フェッチ
- 命令デコード
- 命令実行
    - 演算
    - メモリアクセス
- ライトバック

# 参考資料
- [GitHub - riscv-software-src/riscv-tests](https://github.com/riscv-software-src/riscv-tests)
- FPGAマガジンNo.18
- 

# 後日実装予定の命令
- ecall, ebreak
- csrrw, csrrs, csrrc, csrrwi, csrrsi, csrrci, rdcycle[h], rdtime[h], rdinstret[h]
