class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.2.0"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.2.0/nanoworker_darwin_arm64.tar.gz"
    sha256 "a45f82cb4dc75ffb78694d2999f7ac336fe9e23643b8ee118e28cee6a5777aaa"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.2.0/nanoworker_linux_arm64.tar.gz"
      sha256 "5d7c2451147f394955474c6dbefb94a34088f2bd2371efc199865168d7a08d1a"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.2.0/nanoworker_linux_amd64.tar.gz"
      sha256 "a390ac5c1926cb9483028126ae3db0cc4dd6326efdfab7ad4f108f0f0ada4791"
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
