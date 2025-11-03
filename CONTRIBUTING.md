# Contributing to Itchio 2D Engine

Thank you for your interest in contributing to the Itchio 2D Engine project!

## How to Contribute

### 1. Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists in the [issue tracker](https://github.com/shifty81/Itchio-2d/issues)
2. If not, create a new issue with:
   - Clear description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - System information (OS, compiler, etc.)
   - Relevant logs or screenshots

### 2. Code Contributions

#### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Itchio-2d.git
   cd Itchio-2d
   ```
3. Create a branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Making Changes

1. Follow the existing code style
2. Write clear, descriptive commit messages
3. Add tests if applicable
4. Update documentation as needed
5. Ensure the code builds and tests pass:
   ```bash
   ./verify_build.sh  # or verify_build.bat on Windows
   ```

#### Submitting Changes

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
2. Create a Pull Request with:
   - Clear description of changes
   - Link to related issues
   - Screenshots (if UI changes)
   - Test results

### 3. Documentation Contributions

Help improve our documentation:

- Fix typos or unclear explanations
- Add examples or tutorials
- Create video walkthroughs
- Translate documentation

### 4. Creating Systems

Share your custom game systems:

1. Create a new system DLL following [SYSTEM_DESIGN.md](SYSTEM_DESIGN.md)
2. Include documentation and examples
3. Submit as a PR to `src/Systems/Community/`
4. Include tests demonstrating functionality

### 5. Asset Contributions

Contribute reusable assets:

- Sprites and textures
- Tilesets
- Sound effects
- Music tracks
- Sample game configs

**Note**: Ensure you have rights to share the assets.

## Code Style Guidelines

### C++ Style

- Use C++17 standard features
- Follow existing naming conventions:
  - Classes: `PascalCase`
  - Functions: `PascalCase`
  - Variables: `camelCase`
  - Constants: `UPPER_CASE`
  - Private members: `m_camelCase`
- Use smart pointers where appropriate
- Prefer `const` correctness
- Comment complex logic

### Example:

```cpp
class ExampleSystem : public ISystem {
private:
    int m_frameCount;
    const float MAX_DELTA_TIME = 0.1f;
    
public:
    bool Initialize() override {
        m_frameCount = 0;
        return true;
    }
    
    void Update(float deltaTime) override {
        // Clamp delta time to prevent large jumps
        deltaTime = std::min(deltaTime, MAX_DELTA_TIME);
        m_frameCount++;
    }
};
```

### CMake Style

- Use lowercase commands
- Indent with 4 spaces
- Group related commands
- Comment non-obvious logic

### JSON Style

- Use 2-space indentation
- Follow existing config structure
- Include descriptive field names
- Add comments where helpful (if supported)

## Testing Guidelines

### Writing Tests

- Test one thing per test
- Use descriptive test names
- Include both positive and negative cases
- Test edge cases

### Example:

```cpp
void TestSystemLoading() {
    SystemManager mgr;
    
    // Test successful load
    assert(mgr.LoadSystem("path/to/System.dll"));
    
    // Test invalid path
    assert(!mgr.LoadSystem("invalid/path.dll"));
    
    // Test duplicate load
    assert(mgr.LoadSystem("path/to/System.dll"));
}
```

### Running Tests

Always run tests before submitting:

```bash
cd build/bin
./TestSystemManager
./GameTypeSwitcherDemo
```

## Documentation Guidelines

### Markdown Style

- Use clear headings
- Include code examples
- Add links to related docs
- Keep lines under 100 characters (for readability)

### Code Documentation

- Document public APIs
- Explain non-obvious behavior
- Include usage examples
- Document parameters and return values

```cpp
/// @brief Loads a game system from a DLL
/// @param dllPath Path to the DLL file (relative or absolute)
/// @return true if loaded successfully, false otherwise
/// @note The system must export CreateSystem() and DestroySystem()
bool LoadSystem(const std::string& dllPath);
```

## Review Process

1. **Automated Checks**: CI/CD runs tests automatically
2. **Code Review**: Maintainers review code and provide feedback
3. **Discussion**: Address comments and questions
4. **Approval**: Once approved, PR is merged
5. **Credit**: Contributors are credited in release notes

## Communication

- Be respectful and constructive
- Ask questions if unclear
- Provide context in discussions
- Be patient with review process

## Types of Contributions Welcome

### Beginner-Friendly
- Documentation improvements
- Bug fixes
- Example systems
- Test coverage
- Asset contributions

### Intermediate
- New systems
- Tool improvements
- Performance optimizations
- Platform support

### Advanced
- Graphics API implementations
- Core architecture changes
- Complex systems (ECS, networking)
- Editor features

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Mentioned in project README
- Invited to contributor discussions

## Questions?

- Open a [discussion](https://github.com/shifty81/Itchio-2d/discussions)
- Check existing documentation
- Ask in issues
- Contact maintainers

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Focus on what's best for the project

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Itchio 2D Engine! 🎮
