class Perch < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/upsertco/perch"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.7.0/perch-aarch64-apple-darwin.tar.xz"
      sha256 "5c63ddd0947a4c6adb2352dc369c3cfe764aba3a811ee90f8237bada855c10ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.7.0/perch-x86_64-apple-darwin.tar.xz"
      sha256 "a77ee12bce2fe33aa694a91be02cd1d287d1d7a0b06287166bf3799336cc7bae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.7.0/perch-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0a675f4c8668ec877dbeb511d1110ab6f0d1a36a8fe7b9a4747a87ee08163b51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.7.0/perch-x86_64-unknown-linux-musl.tar.xz"
      sha256 "44ce7a29b70f97b87cce19ac71bd561e84a3626523faafdd987c1ba3694f07e2"
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
