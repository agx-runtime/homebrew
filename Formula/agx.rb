class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.2.0/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b4bf5068e8d2ec543016e98e3f8cfd2097de38e41192dd7f3e8ce00d3f3795f9"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.0/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b4bf5068e8d2ec543016e98e3f8cfd2097de38e41192dd7f3e8ce00d3f3795f9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.2.0/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa98605ab2361a3492338e514c4e0758d301d4d2990a9441231fcdf845cfa527"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.0/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa98605ab2361a3492338e514c4e0758d301d4d2990a9441231fcdf845cfa527"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.2.0/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b93b1b4219cd2f12ddb054ddb737a10b3c9b0a5fdd51888f523ef7a8303a74d"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.0/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b93b1b4219cd2f12ddb054ddb737a10b3c9b0a5fdd51888f523ef7a8303a74d"
    end
  end
  license "AGPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agx" if OS.mac? && Hardware::CPU.arm?
    bin.install "agx" if OS.linux? && Hardware::CPU.arm?
    bin.install "agx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
