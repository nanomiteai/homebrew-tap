class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.6"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.6/nanoworker_darwin_arm64.tar.gz"
    sha256 "f8ea00fcbd1d730244489e653389797f475be4bdd501b8b77bb7e12aa1419d2d"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.6/nanoworker_linux_arm64.tar.gz"
      sha256 "0f2b6b26e2a0091ffdda4ddb7f9767ecf178dc1ac4d31209418fc4854e1dd5ee"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.6/nanoworker_linux_amd64.tar.gz"
      sha256 "c099a0e0b8349bddedab77f42298f2ab8ad901f1016cc675adf9b5002fcdce70"
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
