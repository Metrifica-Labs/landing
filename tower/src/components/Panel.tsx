import { forwardRef, type HTMLAttributes, type ReactNode } from 'react';

interface Props extends Omit<HTMLAttributes<HTMLDivElement>, 'title'> {
  title: ReactNode;
  meta?: ReactNode;
  live?: boolean;
  /** Extra controls rendered at the right of the bar. */
  actions?: ReactNode;
}

/** The instrument frame every demo sits in: status bar plus crop marks. */
export const Panel = forwardRef<HTMLDivElement, Props>(function Panel(
  { title, meta, live, actions, className, children, ...rest },
  ref,
) {
  return (
    <div ref={ref} className={`panel${className ? ` ${className}` : ''}`} {...rest}>
      <i className="crop" aria-hidden="true" />
      <div className="panel-bar">
        <span className="panel-title">{title}</span>
        {meta && <span className="panel-meta">{meta}</span>}
        {live && (
          <span className="panel-live">
            <span className="dot" aria-hidden="true" /> ao vivo
          </span>
        )}
        {actions && <span className="panel-actions">{actions}</span>}
      </div>
      {children}
    </div>
  );
});
