import { forwardRef, InputHTMLAttributes } from 'react'

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string
  error?: string
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && (
          <label className="block text-sm font-medium text-neutral-dark mb-2">
            {label}
          </label>
        )}
        <input
          ref={ref}
          className={`
            w-full px-4 py-3 rounded-lg border
            ${error ? 'border-primary' : 'border-gray-300'}
            focus:outline-none focus:ring-2
            ${error ? 'focus:ring-primary' : 'focus:ring-primary/50'}
            transition-all duration-200
            ${props.disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white'}
            ${className}
          `}
          {...props}
        />
        {error && (
          <p className="mt-1 text-sm text-primary">
            {error}
          </p>
        )}
      </div>
    )
  }
)

Input.displayName = 'Input'
