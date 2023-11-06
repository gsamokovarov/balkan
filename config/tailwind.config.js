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
        brutal: "4px 4px #000",
        "brutal-md": "6px 6px #000",
      },
      colors: {
        brand: {
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
            "--tw-prose-body": theme("colors.black"),
            "--tw-prose-headings": theme("colors.black"),
            "--tw-prose-lead": theme("colors.black"),
            "--tw-prose-links": theme("colors.brand[900]"),
            "--tw-prose-bold": theme("colors.black"),
            "--tw-prose-counters": theme("colors.stone[800]"),
            "--tw-prose-bullets": theme("colors.stone[800]"),
            "--tw-prose-hr": theme("colors.brand[300]"),
            "--tw-prose-quotes": theme("colors.brand[900]"),
            "--tw-prose-quote-borders": theme("colors.brand[300]"),
            "--tw-prose-captions": theme("colors.stone[800]"),
            "--tw-prose-code": theme("colors.brand[900]"),
            "--tw-prose-pre-code": theme("colors.brand[50]"),
            "--tw-prose-pre-bg": theme("colors.brand[950]"),
            "--tw-prose-th-borders": theme("colors.black"),
            "--tw-prose-td-borders": theme("colors.stone[500]"),
            img: {
              "border-width": defaultTheme.borderWidth[2],
              "border-color": theme("colors.black"),
              "border-radius": defaultTheme.borderRadius.md,
            },
          },
        },
      }),
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
