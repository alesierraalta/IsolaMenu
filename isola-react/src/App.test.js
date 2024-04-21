// app.test.js

import { render, screen, fireEvent } from '@testing-library/react';
import App from './App';

test('renders learn react link and handles click', () => {
  render(<App />);
  const linkElement = screen.getByText(/learn react/i);
  expect(linkElement).toBeInTheDocument();

  // Simula un click en el enlace
  fireEvent.click(linkElement);

  // Verifica si el click cambia algún estado o contenido en la app
  const updatedText = screen.getByText(/content changed after click/i);
  expect(updatedText).toBeInTheDocument();
});

test('renders app and toggles content', () => {
  render(<App />);
  const toggleButton = screen.getByRole('button', { name: /toggle content/i });
  expect(screen.queryByText(/dynamic content/i)).toBeNull();

  fireEvent.click(toggleButton);
  expect(screen.getByText(/dynamic content/i)).toBeInTheDocument();

  fireEvent.click(toggleButton);
  expect(screen.queryByText(/dynamic content/i)).toBeNull();
});