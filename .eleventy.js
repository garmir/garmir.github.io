// Eleventy Configuration for garmir.io
// SuperClaude v3.777 - Space-Optimized Build System

module.exports = function(eleventyConfig) {
  // Copy assets directly (no processing by 11ty)
  eleventyConfig.addPassthroughCopy("src/assets/images");
  eleventyConfig.addPassthroughCopy("src/assets/css");
  eleventyConfig.addPassthroughCopy("src/assets/js");

  // Copy root files
  eleventyConfig.addPassthroughCopy("src/robots.txt");
  eleventyConfig.addPassthroughCopy("src/sitemap.xml");

  // Add collections
  eleventyConfig.addCollection("posts", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/content/posts/*.md")
      .sort((a, b) => b.date - a.date);
  });

  eleventyConfig.addCollection("projects", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/content/projects/*.md");
  });

  // Markdown configuration
  const markdownIt = require("markdown-it");
  const md = markdownIt({
    html: true,
    linkify: true,
    typographer: true
  });
  eleventyConfig.setLibrary("md", md);

  // Filters for date formatting
  eleventyConfig.addFilter("dateDisplay", (dateObj) => {
    return dateObj.toISOString().split('T')[0];
  });

  // Filter for ASCII header generation
  eleventyConfig.addShortcode("asciiHeader", function(title) {
    const border = "─".repeat(65);
    return `<div class="ascii-header" role="img" aria-label="Section: ${title}">
  <div aria-hidden="true">
┌${border}┐
│ ${title.padEnd(64)}│
├${border}┤
  </div>
</div>`;
  });

  // Configuration
  return {
    dir: {
      input: "src",
      output: "dist",
      includes: "_components",
      layouts: "_layouts",
      data: "_data"
    },
    templateFormats: ["html", "md", "njk", "11ty.js"],
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    dataTemplateEngine: "njk"
  };
};
