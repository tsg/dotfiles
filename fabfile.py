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
def deploy_all():
    deploy_fish()


@task
def save_all():
    save_fish()
