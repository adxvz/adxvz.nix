_:

{

  programs.git = {
    enable = true;
  # userName = "${vars.name}";
  # userEmail = "${vars.email}";
   userName = "Adam Cooper";
   userEmail = "85442143+adxvz@users.noreply.github.com";
   signing ={
     signByDefault = true;
     key = "4C5D067A827FA98D60EA4742B9E578B362BE5DC6";
   };
   extraConfig = {
     init.defaultBranch = "main";
   };

  };
}
