class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.6/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2aac03dccf98480a9d8aec8fe4dc79481a17d200db23d1e146240021ef04384c"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.6/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2aac03dccf98480a9d8aec8fe4dc79481a17d200db23d1e146240021ef04384c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.6/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b8dea9fe384ec17bce391a18e2784a0fe7023d07e89e5c62c29d1920114157e"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.6/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b8dea9fe384ec17bce391a18e2784a0fe7023d07e89e5c62c29d1920114157e"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.6/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a9084289514897bdd2a5130e98f94b027d87c3e0ad61b827ac3db124341888de"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.6/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a9084289514897bdd2a5130e98f94b027d87c3e0ad61b827ac3db124341888de"
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
