class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.4/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "e937b9325e98ccafe3ab1133c48b15d417c84655ba6eccb31d96fbed172c4e87"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.4/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "e937b9325e98ccafe3ab1133c48b15d417c84655ba6eccb31d96fbed172c4e87"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.4/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b8c2a8b8ad4afaf94b2d8318dec9c6f0f116244bde341624c2a8478af1cc454"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.4/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b8c2a8b8ad4afaf94b2d8318dec9c6f0f116244bde341624c2a8478af1cc454"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.4/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70518b06a6502c181c4378ff36da0c2c16e05e725f82b02c9a6def245a6ab325"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.4/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70518b06a6502c181c4378ff36da0c2c16e05e725f82b02c9a6def245a6ab325"
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
