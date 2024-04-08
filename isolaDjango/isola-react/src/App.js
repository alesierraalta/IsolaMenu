import React from 'react';
import CategoriaList from './components/CategoriaList';
import './App.css';


function App() {
  return (
    <div className="App">
      <header className="App-header">
        <CategoriaList /> {/* Asegúrate de que este componente se esté renderizando */}
      </header>
    </div>
  );
}

export default App;
