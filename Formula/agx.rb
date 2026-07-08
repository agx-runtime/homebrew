class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.3/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "f48a80406f8fbb8d27eac2ff44aceb44aaa032ff4bb561269042a0ad673072ba"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.3/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "f48a80406f8fbb8d27eac2ff44aceb44aaa032ff4bb561269042a0ad673072ba"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.3/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "556209b08a3e77935d2807acb291081e352a41b666418631046746bbbeea4c25"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.3/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "556209b08a3e77935d2807acb291081e352a41b666418631046746bbbeea4c25"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.3/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f904f5bc0c9e9f92f23c561f9831963c4e7527851f8fcd918fe93a555c3185ca"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.3/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f904f5bc0c9e9f92f23c561f9831963c4e7527851f8fcd918fe93a555c3185ca"
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
