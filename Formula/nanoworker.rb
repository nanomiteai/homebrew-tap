class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.3"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.3/nanoworker_darwin_arm64.tar.gz"
    sha256 "a40ca0cb91f74b773363005a58544e7d8138dd841ccc23ae7229a13c186bf9b7"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.3/nanoworker_linux_arm64.tar.gz"
      sha256 "0a7bbe99810848659b455daf177c3385e27a70e98d27adca3628a6a8db01f865"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.3/nanoworker_linux_amd64.tar.gz"
      sha256 "5852dfd18deb0690b7b4e86d8151e5c7a95458970f3aa2e61dbed8dafd11bd06"
    end
  end

  def install
    bin.install "nanoworker"
    (etc/"nanomite").install "nanomite.yaml.sample"
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

      2. Set your worker token (get it from the nanoweb UI under Workers):
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
