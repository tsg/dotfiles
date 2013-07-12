#!/bin/python

from fabric.api import (
    local,
    task,
    run,
    put,
    get,
    env,
    cd,
    sudo
)
from fabric.contrib import files
import json

if not env.hosts:
    # by default do stuff on localhost
    env.hosts = ['localhost']


@task
def deploy_fish():
    run("aptitude install fish")
    deploy_fish_config()
    run("chsh -s /usr/bin/fish")


@task
def deploy_fish_config():
    """
    Deploys fish shell configuration.
    """
    put("fish/config.fish", "/tmp/config.fish")
    run("mkdir -p ~/.config/fish")
    run("cp /tmp/config.fish ~/.config/fish/")


@task
def save_fish_config():
    """
    Saves fish shell configuration.
    """
    get("~/.config/fish/config.fish", "fish/")


@task
def deploy_git():
    """
    Deploys fish shell configuration.
    """
    put("git/gitconfig", "~/.gitconfig")


@task
def save_git_config():
    """
    Saves fish shell configuration.
    """
    get("~/.gitconfig", "git/gitconfig")


@task
def save_vim_config():
    """
    Saves vimrc configuration.
    """
    get("~/.vimrc", "vim/vimrc")
    get("~/.vim/colors/*", "vim/colors/")


@task
def deploy_vim_config():
    """
    Deploys vim configuration.
    """
    put("vim/vimrc", "~/.vimrc")
    run("mkdir -p ~/.vim/colors")
    put("vim/colors/*", ".vim/colors/")


@task
def deploy_vim():
    """
    Deploys vim configuration and the pathogen plugins.
    """
    deploy_vim_config()
    install_pathogen_plugins()


@task
def deploy_hg():
    """
    Deploys the HG configuration files, including the extensions.
    """
    sudo("aptitude install mercurial")
    extensions = [
        "https://bitbucket.org/sjl/hg-prompt",
        "https://bitbucket.org/rfv/xgraft",
        "https://bitbucket.org/astiob/hgshelve",
    ]
    run("mkdir -p ~/sw")
    with cd("~/sw"):
        for url in extensions:
            run("hg clone {}".format(url))
    put("hg/.hgrc", "~/.hgrc")


@task
def install_pathogen_plugins():
    """
    Downloads and installs the Pathogen modules as listed in
    vim/pathogen_plugins.json
    """
    run("mkdir -p ~/.vim/bundle")
    run("mkdir -p ~/.vim/autoload")
    if not files.exists("~/.vim/autoload/pathogen.vim"):
        run("curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim")

    pathogen_plugins = json.load(open("vim/pathogen_plugins.json"))
    for plugin in pathogen_plugins:
        dir_ = "~/.vim/bundle/{0}".format(plugin["name"])
        if files.exists(dir_):
            print("Plugin {0} already installed".format(plugin["name"]))
            continue

        if not "git" in plugin:
            print("Don't know how to install plugin {0}".format(plugin["name"]))
            continue

        with cd("~/.vim/bundle"):
            run("git clone {0}".format(plugin["git"]))

        print("Plugin {0} installed".format(plugin["name"]))


@task
def deploy_iterm():
    """
    Deploys the iTerm2 settings file.
    """
    local("cp iterm/com.googlecode.iterm2.plist ~/Library/Preferences/")


@task
def save_iterm():
    """
    Deploys the iTerm2 settings file.
    """
    local("cp ~/Library/Preferences/com.googlecode.iterm2.plist iterm/")


@task
def deploy_all():
    deploy_fish()
    deploy_git()
    deploy_vim()
    deploy_iterm()


@task
def save_all():
    save_fish_config()
    save_git_config()
    save_vim_config()
    save_iterm()
