module.exports = {
  content: ["./index.html", "./src/**/*.{gleam,mjs}"],
  theme: {
    extend: {
      keyframes: {
        'enter-from-below': {
          '0%': {
            bottom: '-10px'
          },
        },
        'exit-below': {
          '100%': {
            bottom: '-10px'
          }
        }
      },
      animation: {
        'enter-from-below': 'enter-from-below .6s',
        'exit-below': 'exit-below .6s'
      }
    },
  },
  plugins: [],
};
