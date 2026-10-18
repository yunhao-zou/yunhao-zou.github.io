# al-folio v1.2 升级记录

升级日期：2026-10-18。

上游版本：[al-folio v1.2](https://github.com/alshedivat/al-folio/releases/tag/v1.2)，Git 标签对应提交 `b95d6d6`。

## 本次更新

- 从 2024 年的独立模板副本迁移到 v1.2 插件架构，使用固定版本的 `al_folio_core 1.0.15`、`al_folio_cv 1.0.2` 等插件。
- 使用新版布局、导航、CV 日期处理、图片预览、图标与主题运行代码；移除仓库中已由插件提供的旧运行文件。
- 包含新版可选能力：marimo 交互式 Python Notebook、邮箱保护和从右到左的语言支持。这些功能沿用上游默认关闭状态。
- 保留姓名、简介、照片、联系方式、论文、新闻、CV、奖项、服务经历和原有页面地址。
- 延续浅色、深色和跟随系统三种主题，以及已验证的青色链接、红色强调文字和表格对比度。
- 更新构建部署流程；不再使用旧的 CSS 二次压缩步骤，以免破坏 Tailwind 的变量表达式。
- 社交链接转移到 `_data/socials.yml`；首页新闻配置转移到首页 front matter；CV 明确使用 `jsonresume` 格式。
- 站点地图由 `jekyll-sitemap` 按实际页面自动生成。

## 有意保留的本地覆盖

- `_layouts/about.liquid`：在新版首页布局中保留奖项和服务章节。
- `_includes/news.liquid`：支持每条新闻的 `date_format`，只显示已知的年或月份；没有设置时沿用上游的完整日期格式。
- `assets/css/main.scss`：沿用新版入口，额外加载 `_sass/_site.scss` 中的个人配色和紧凑布局。

这三处覆盖已经过审查并记录于 `.al-folio-overrides.yml`。其中新闻覆盖在毕业后信息更新时加入。后续升级插件后运行：

```bash
bundle exec al-folio upgrade audit
bundle exec al-folio upgrade overrides audit
```

`_plugins/local-preview.rb` 仅在开发模式且本地覆盖配置明确启用时，允许 Jekyll LiveReload 使用本机 35729 端口。生产环境的 CSP 保持上游默认值。

## 兼容性说明

CV 使用新版统一布局，日期徽标按年份显示；JSON 文件中的日期按实际已知的年份或月份记录。

现有模板示例文章 `_posts/2023-03-21-tables.md` 还包含四个旧式 `data-toggle` 标记，因此启用了上游提供的 Bootstrap 兼容层。当前 v1.2 支持此模式；升级到 v1.3 或 v2 前需要再次检查这篇示例文章。迁移审计没有阻断项。

## 备份

升级前完整源码、文件哈希清单及未提交修改补丁保存在工作目录的：

`F:\文档\Resume\.local\backups\before-al-folio-v1.2`

该备份不在网站发布目录中。线上站点在另行推送代码后才会更新。

## 验证结果

- 开发构建、完整生产构建和上游生产 CSS 回归检查通过。
- 上游升级 CLI 集成检查通过；迁移审计为 0 个阻断项。
- 2 个核心文件覆盖已确认；4 个非阻断提示均来自保留的旧表格示例文章。
- 45 个论文、新闻、照片、PDF 和 JSON 文件与升级前哈希一致。
- 升级前后各有 93 个 HTML 页面，原页面路径全部保留；没有新增站内断链。
- 实际浏览器已检查首页 News、论文列表和摘要展开、CV 内容与 PDF 下载链接，以及浅色、深色和跟随系统三种主题切换。
- 生产构建未包含本地 LiveReload 的端口放行配置。

本次使用的核心验证命令（在已配置的 WSL Ruby/Bundler 环境中执行）：

```bash
bundle _4.0.6_ exec jekyll build --config _config.yml,../.local/jekyll-local.yml --destination ../.local/site-v1
JEKYLL_ENV=production bundle _4.0.6_ exec jekyll build --config _config.yml --destination ../.local/site-v1-production
bundle _4.0.6_ exec bash test/integration_css_minify.sh
bundle _4.0.6_ exec bash test/integration_upgrade_cli.sh
bundle _4.0.6_ exec al-folio upgrade audit
bundle _4.0.6_ exec al-folio upgrade overrides audit
```

格式检查使用锁定版本的 Prettier，对迁移过的配置、首页布局、个人样式和现有工作流执行 `--check`。
