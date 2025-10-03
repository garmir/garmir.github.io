// PostCSS Configuration for garmir.io
// CSS optimization and processing

module.exports = {
  plugins: [
    require('autoprefixer'),
    require('cssnano')({
      preset: ['default', {
        discardComments: {
          removeAll: true,
        },
        normalizeWhitespace: true,
        minifyFontValues: true,
        minifySelectors: true,
      }],
    }),
  ],
};
