{ config, ... }:
{
  home.file = {
    ".zprofile".source = ../../modules/zsh/.zprofile;
    ".zshenv".source = ../../modules/zsh/.zshenv;
    ".zshrc".source = ../../modules/zsh/.zshrc;
  };
}
