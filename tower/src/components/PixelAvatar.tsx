interface SpriteProps {
  shirt: string;
  hair?: string;
  skin?: string;
  chief?: boolean;
}

interface Props extends SpriteProps {
  helper?: boolean;
  size?: number;
  title?: string;
}

/** The sprite itself on a 16×20 grid, so SVG scenes can place it directly. */
export function Sprite({ shirt, hair = '#2b1d16', skin = '#e8b98f', chief }: SpriteProps) {
  return (
    <>
      <rect x="4" y="15" width="3" height="5" fill="#1b2236" />
      <rect x="9" y="15" width="3" height="5" fill="#1b2236" />
      <rect x="2" y="8" width="12" height="8" fill={shirt} />
      <rect x="11" y="8" width="3" height="8" fill="#000" opacity="0.2" />
      {chief && (
        <>
          <rect x="6" y="8" width="4" height="2" fill="#f4f6ff" />
          <rect x="7" y="10" width="2" height="4" fill="#10162a" />
        </>
      )}
      <rect x="3.5" y="1" width="9" height="8" fill={skin} />
      <rect x="2.5" y="0" width="11" height="3" fill={hair} />
      <rect x="2.5" y="2" width="2" height="4" fill={hair} />
      <rect x="6" y="5" width="1" height="2" fill="#10162a" />
      <rect x="10" y="5" width="1" height="2" fill="#10162a" />
    </>
  );
}

/** Same sprite grammar as the Town renderer, as a crisp inline SVG. */
export function PixelAvatar({ helper, size = 28, title, ...sprite }: Props) {
  return (
    <svg
      className={`pxa${helper ? ' pxa-helper' : ''}`}
      width={size}
      height={size * 1.25}
      viewBox="0 0 16 20"
      shapeRendering="crispEdges"
      role={title ? 'img' : undefined}
      aria-label={title}
      aria-hidden={title ? undefined : true}
    >
      <Sprite {...sprite} />
    </svg>
  );
}
