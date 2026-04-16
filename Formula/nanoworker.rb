class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.8"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.8/nanoworker_darwin_arm64.tar.gz"
    sha256 "93b62d494e75818743bf1fbaa2968e0d4d28667387a1801137ba8393659d974a"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.8/nanoworker_linux_arm64.tar.gz"
      sha256 "915b3d5874b557710e6d878ff875ef3ee0e890361ea2908f90e246920db58b28"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.8/nanoworker_linux_amd64.tar.gz"
      sha256 "1f2b685e253e9a1f429501abf581256e0f222e24abcddd756e8544b31a3a8989"
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
