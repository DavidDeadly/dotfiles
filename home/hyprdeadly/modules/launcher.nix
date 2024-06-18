{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      width = 700;
      allow_images = true;
    };

    style = ''
      * {
        border-radius: 15px;
      }

      window {
        font-size: 32px;
        font-family: "Roboto mono Medium";
        background-color: transparent;
        color: #cdd6f4;
      }

      #input {
        border: none;
        background-color: rgba(17, 17, 27, .9);
        color: #89b4fa;
        margin-bottom: 15px;
        padding: 10px;
      }

      #inner-box {
        background-color: rgba(30, 30, 46, .9);
      }

      image {
        margin-left: 10px;
        margin-right: 10px;
      }

      #entry {
        padding: 10px;
      }

      #entry:selected {
        outline: none;
        background-color: #94e2d5;
        background: linear-gradient(90deg, #94e2d5, #cba6f7);
      }

      #text:selected {
        color: #333333;
      }
    '';
  };
}
