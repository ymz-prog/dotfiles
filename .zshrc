# Powerlevel10kのインスタントプロンプトを有効にします。~/.zshrcの先頭に近いところにあるはずです。
# コンソール入力を必要とする初期化コード（パスワードプロンプト、[y/n]確認など）は、このブロックの上に置く必要があります。
# それ以外のものは、このブロックの下に置くことができます。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

### fast-syntax-highlit,zsh-completions,zsh-autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

### 補完機能(compinit)
zstyle ':completion:*' matcher-list 'm:{[:lower:]}'='{[:upper:]}' #小文字でも大文字にマッチ
zstyle ':completion:*:default' menu select=2 #menu: 候補の背景色がつくselect: 指定した候補以上になると選択(背景色が変わる)
bindkey "^[[Z" reverse-menu-complete #Shift-Tab で自動補完のカーソルを戻す

# 名前で色を付けるようにする
autoload colors
colors
# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors "${LS_COLORS}"

autoload -Uz compinit && compinit

### p10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


### anyframe(peco用ライブラリ)
zinit light mollifier/anyframe
#fpath=(/path/to/dir/anyframe(N-/) $fpath)
#autoload -Uz anyframe-init
#anyframe-init

# cdrコマンド用anyframe設定
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# anyframeキーバインド
bindkey '^r' anyframe-widget-cdr
bindkey '^f' anyframe-widget-execute-history
bindkey '^b' anyframe-widget-checkout-git-branch
bindkey '^g' anyframe-widget-cd-ghq-repository


### asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

### 履歴関連のオプション
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
HISTSIZE=10000
SAVEHIST=10000

### alias
alias ll='ls -alhFGT'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias oless='less'
alias less='/usr/share/vim/vim90//macros/less.sh'
alias sail='zsh vendor/bin/sail'
