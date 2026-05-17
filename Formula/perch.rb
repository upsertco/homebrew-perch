class Perch < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/upsertco/perch"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.4.0/perch-aarch64-apple-darwin.tar.xz"
      sha256 "7e859975409bea4fa61d9fafab592c443788ebc430c0e3cf021dde67cd1d8ae7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.4.0/perch-x86_64-apple-darwin.tar.xz"
      sha256 "632b232790c1124020c08f2ce8394edada3abeaefdf73d8f354c2d64ae98b247"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.4.0/perch-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0456c604810159d80db726104b020d8414d0da42bd6717a235e661de689b2baf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.4.0/perch-x86_64-unknown-linux-musl.tar.xz"
      sha256 "346061de730b1899bea61389d3dd3c33b5ca3df26809864aec1829097b457852"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "git-perch", "perch" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-perch", "perch" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-perch", "perch" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-perch", "perch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
