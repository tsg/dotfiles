from fabric.api import (
    local,
    task,
)


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
def deploy_all():
    deploy_fish()
    deploy_git()


@task
def save_all():
    save_fish()
    save_git()
