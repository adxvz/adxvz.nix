{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.audio;
in
{
  options.modules.audio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PipeWire with real-time kernel support and optionally disable PulseAudio.";
    };

    disablePulseAudio = mkOption {
      type = types.bool;
      default = true;
      description = "Disable PulseAudio when using PipeWire.";
    };

    rtkitEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable real-time kernel support via rtkit.";
    };

    pipewireEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable PipeWire.";
    };

    pipewireAlsaEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ALSA support in PipeWire.";
    };

    pipewireAlsa32BitSupport = mkOption {
      type = types.bool;
      default = true;
      description = "Enable 32-bit ALSA support in PipeWire.";
    };

    pipewirePulseEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable PulseAudio compatibility in PipeWire.";
    };
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = !cfg.disablePulseAudio;

    security.rtkit.enable = cfg.rtkitEnable;

    services.pipewire = {
      enable = cfg.pipewireEnable;
      alsa.enable = cfg.pipewireAlsaEnable;
      alsa.support32Bit = cfg.pipewireAlsa32BitSupport;
      pulse.enable = cfg.pipewirePulseEnable;
    };
  };
}
