class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.9"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.9/nanoworker_darwin_arm64.tar.gz"
    sha256 "542b39f8fa0b081d236512aaa5cc6ad9b7c4936930ca9099b09ba48d2e92a74f"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.9/nanoworker_linux_arm64.tar.gz"
      sha256 "1e93a1ad10e6a70dcfdd04652fe956934a0edff353195511c17e39454480c9aa"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.9/nanoworker_linux_amd64.tar.gz"
      sha256 "5c8030211ca29afd446af3b729bbb9a9977d5c9a86d9837bd13978f8f4312ab9"
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
