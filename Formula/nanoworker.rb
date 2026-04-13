class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.0.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nanomiteai/nanoworker/releases/download/v#{version}/nanoworker_darwin_arm64.tar.gz"
      sha256 "placeholder"
    else
      url "https://github.com/nanomiteai/nanoworker/releases/download/v#{version}/nanoworker_darwin_amd64.tar.gz"
      sha256 "placeholder"
    end
  end

  def install
    bin.install "nanoworker"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoworker version")
  end
end
