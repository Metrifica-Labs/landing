import { Nav } from './components/Nav';
import { Elevator } from './components/Elevator';
import { Hero } from './components/Hero';
import { Shift } from './components/Shift';
import { Bottleneck } from './components/Bottleneck';
import { Team } from './components/Team';
import { Channels } from './components/Channels';
import { Pipeline } from './components/Pipeline';
import { Collab } from './components/Collab';
import { Brain } from './components/Brain';
import { Safety } from './components/Safety';
import { Results } from './components/Results';
import { FinalCta, Footer } from './components/Closing';

export function App() {
  return (
    <>
      <a className="skip" href="#conteudo">
        Pular para o conteúdo
      </a>
      <Nav />
      <Elevator />
      <main id="conteudo">
        <Hero />
        <Shift />
        <Bottleneck />
        <Team />
        <Channels />
        <Pipeline />
        <Collab />
        <Brain />
        <Safety />
        <Results />
        <FinalCta />
      </main>
      <Footer />
    </>
  );
}
