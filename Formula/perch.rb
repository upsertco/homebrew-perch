class Perch < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/upsertco/perch"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.5.1/perch-aarch64-apple-darwin.tar.xz"
      sha256 "68e705ed184ff46b33922df1b042bb720b1bb464162daf45ae01b00a38fe4903"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.5.1/perch-x86_64-apple-darwin.tar.xz"
      sha256 "eb6475147c3224c715d2fd871f76d6afa25786cf998c2fc1402dcd643b5dffb2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.5.1/perch-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7879ebba79f81b8cf4fe22553cd99af1718a03f85a80c396b3d756fe669a0600"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.5.1/perch-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6a34786b8f701fbba044ab4914b831e59aeb9d0493f4daafcfe88da4001ad568"
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
