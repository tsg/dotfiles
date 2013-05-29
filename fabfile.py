from fabric.api import (
    local,
    task,
    lcd,
    env
)
import os
import json


@task
def deploy_fish():
    """
    Deploys fish shell configuration.
    """
    local("cp fish/config.fish ~/.config/fish/")


@task
def save_fish():
    """
    Saves fish shell configuration.
    """
    local("cp ~/.config/fish/config.fish fish/")


@task
def deploy_git():
    """
    Deploys fish shell configuration.
    """
    local("cp git/gitconfig ~/.gitconfig")


@task
def save_git():
    """
    Saves fish shell configuration.
    """
    local("cp ~/.gitconfig git/gitconfig")


@task
def save_vim():
    """
    Saves vimrc configuration.
    """
    local("cp ~/.vimrc vim/vimrc")


@task
def deploy_vim():
    """
    Deploys vim configuration and the pathogen plugins.
    """
    local("cp vim/vimrc ~/.vimrc")
    install_pathogen_plugins()


@task
def install_pathogen_plugins():
    """
    Downloads and installs the Pathogen modules as listed in
    vim/pathogen_plugins.json
    """
    pathogen_plugins = json.load(open("vim/pathogen_plugins.json"))
    for plugin in pathogen_plugins:
        dir_ = os.path.expanduser("~/.vim/bundle/{0}".format(plugin["name"]))
        if os.path.isdir(dir_):
            print("Plugin {0} already installed".format(plugin["name"]))
            continue

        if not "git" in plugin:
            print("Don't know how to install plugin {0}".format(plugin["name"]))
            continue

        with lcd("~/.vim/bundle"):
            local("git clone {0}".format(plugin["git"]))

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
    save_fish()
    save_git()
    save_vim()
    save_iterm()
