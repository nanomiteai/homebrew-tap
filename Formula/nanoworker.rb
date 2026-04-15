class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.7"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.7/nanoworker_darwin_arm64.tar.gz"
    sha256 "bc27059ad66c2587dc81e923bd1887db9d0e60dc04a7d616cc55e00cefc43662"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.7/nanoworker_linux_arm64.tar.gz"
      sha256 "640e5e48e8d8e86e14da4f2e9ae80dd34c9fc25ddc7da2d2f3f6972f49130d2e"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.7/nanoworker_linux_amd64.tar.gz"
      sha256 "1642cd4ffc5d59504c741962936ff9299cb89479d1fe6c160b48f96e34299c62"
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
