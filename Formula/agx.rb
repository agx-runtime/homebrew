class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.2.1/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b822de0f39a19ded39969d81c7bf01164ac955fc7eee9182435ceda39a75fbed"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.1/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b822de0f39a19ded39969d81c7bf01164ac955fc7eee9182435ceda39a75fbed"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.2.1/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a778403660505c23307a8067436d3b7a7452880ac29c44e7ef825e92206c8163"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.1/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a778403660505c23307a8067436d3b7a7452880ac29c44e7ef825e92206c8163"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.2.1/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fdbebea4e484d40c246478ef237a2a1ecf711640f495f164327f1dba19ef8d4b"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.2.1/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fdbebea4e484d40c246478ef237a2a1ecf711640f495f164327f1dba19ef8d4b"
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
