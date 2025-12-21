/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#E63946',
          dark: '#C1121F',
          light: '#F8B4B4',
        },
        accent: {
          DEFAULT: '#FCA311',
          dark: '#F77F00',
        },
        neutral: {
          light: '#F1FAEE',
          DEFAULT: '#457B9D',
          dark: '#1D3557',
        },
      },
    },
  },
  plugins: [],
}
