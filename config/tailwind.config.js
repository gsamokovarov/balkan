const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  future: {
    hoverOnlyWhenSupported: true,
  },
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
      },
      boxShadow: {
        brutal: "4px 4px #fff",
        "brutal-md": "6px 6px #fff",
      },
      colors: {
        current: "currentColor",
        banitsa: {
          50: "#FDF2F3",
          100: "#FCE9EB",
          200: "#F8CED3",
          300: "#F2ABB2",
          400: "#EB7F8A",
          500: "#E03647",
          600: "#D42133",
          700: "#B51C2B",
          800: "#9F1926",
          900: "#7A131D",
          950: "#400A0F",
        },
        x: {
          cyan: "#B1E7F6",
          lime: "#90EE90",
          purple: "#C4A1FF",
          yellow: "#FDF2B3",
          magenta: "#FFB2EF",
          green: "#7FBC8C",
          orange: "#F6C945",
        },
      },
      typography: ({ theme }) => ({
        DEFAULT: {
          css: {
            img: {
              "border-width": defaultTheme.borderWidth[2],
              "border-color": theme("colors.white"),
              "border-radius": defaultTheme.borderRadius.md,
            },
          },
        },
      }),
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
