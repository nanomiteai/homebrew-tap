class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.2"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.2/nanoworker_darwin_arm64.tar.gz"
    sha256 "ebe30e884c3b48cdb83462cf7b2e2bf07e89340dfc2cdfaf21cd85b44fabcd5f"
  end

  on_linux do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.2/nanoworker_linux_arm64.tar.gz"
    sha256 "ab7efbc42343e518bc29743ec6d81463cf74d4dcc50adc8e8ced1d34a57cae77"
  end

  def install
    bin.install "nanoworker"
    etc.install "nanomite.yaml.sample" => "nanomite/nanomite.yaml.sample"
  end

  def post_install
    (var/"log/nanomite").mkpath
  end

  service do
    run [opt_bin/"nanoworker", "run"]
    keep_alive true
    log_path var/"log/nanomite/nanoworker.log"
    error_log_path var/"log/nanomite/nanoworker.log"
    working_dir var
  end

  def caveats
    <<~EOS
      To get started:

      1. Copy the sample config and edit it:
         mkdir -p ~/.config/nanomite
         cp #{etc}/nanomite/nanomite.yaml.sample ~/.config/nanomite/nanomite.yaml
         chmod 600 ~/.config/nanomite/nanomite.yaml

      2. Set your server and token:
         \$EDITOR ~/.config/nanomite/nanomite.yaml

         Or use the token command:
         nanoworker token set <your-worker-token>

      3. Start the service:
         brew services start nanoworker

      Logs: #{var}/log/nanomite/nanoworker.log
      Config: ~/.config/nanomite/nanomite.yaml
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoworker version")
  end
end
