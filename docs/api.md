---
layout: default
title: API reference
nav_order: 3
---

<!-- Warning: AUTO-GENERATED file, don't edit. Add code comments to your Ruby instead <3 -->

# API

## Class methods

### `.config` → [ActiveSupport::OrderedOptions]

Returns the current config.

### `.identifier` → [String]

The file path of the component Ruby file.

### `.new(...)`

Redefine `new` so we can pre-allocate instance variables to optimize
for Ruby object shapes.

### `.sidecar_files(extensions)`

Find sidecar files for the given extensions.

The provided array of extensions is expected to contain
strings starting without the dot, example: `["erb", "haml"]`.

For example, one might collect sidecar CSS files that need to be compiled.

### `.strip_trailing_whitespace(value = true)`

Strips trailing whitespace from templates before compiling them.

```ruby
class MyComponent < ViewComponent::Base
  strip_trailing_whitespace
end
```

### `.strip_trailing_whitespace?` → [Boolean]

Whether trailing whitespace will be stripped before compilation.

### `.with_collection(collection, spacer_component: nil, **args)`

Render a component for each element in a collection ([documentation](/guide/collections)):

```ruby
render(ProductsComponent.with_collection(@products, foo: :bar))
```

### `.with_collection_parameter(parameter)`

Set the parameter name used when rendering elements of a collection ([documentation](/guide/collections)):

```ruby
with_collection_parameter :item
```

## Instance methods

### `#before_render` → [void]

Called before rendering the component. Override to perform operations that
depend on having access to the view context, such as helpers.

### `#content` → [String]

The content passed to the component instance as a block.

### `#content?` → [Boolean]

Whether `content` has been passed to the component.

### `#controller` → [ActionController::Base]

The current controller. Use sparingly as doing so introduces coupling
that inhibits encapsulation & reuse, often making testing difficult.

### `#current_template`

Returns the value of attribute current_template.

### `#helpers` → [ActionView::Base]

A proxy through which to access helpers. Use sparingly as doing so introduces
coupling that inhibits encapsulation & reuse, often making testing difficult.

### `#output_postamble` → [String]

Optional content to be returned after the rendered template.

### `#output_preamble` → [String]

Optional content to be returned before the rendered template.

### `#render?` → [Boolean]

Override to determine whether the ViewComponent should render.

### `#render_in(view_context, &block)` → [String]

Entrypoint for rendering components.

- `view_context`: ActionView context from calling view
- `block`: optional block to be captured within the view context

Returns HTML that has been escaped by the respective template handler.

### `#render_parent`

Subclass components that call `super` inside their template code will cause a
double render if they emit the result.

```erb
<%= super %> # double-renders
<% super %> # doesn't double-render
```

`super` also doesn't consider the current variant. `render_parent` renders the
parent template considering the current variant and emits the result without
double-rendering.

### `#render_parent_to_string`

Renders the parent component to a string and returns it. This method is meant
to be used inside custom #call methods when a string result is desired, eg.

```ruby
def call
  "<div>#{render_parent_to_string}</div>"
end
```

When rendering the parent inside an .erb template, use `#render_parent` instead.

### `#request` → [ActionDispatch::Request]

The current request. Use sparingly as doing so introduces coupling that
inhibits encapsulation & reuse, often making testing difficult.

### `#set_original_view_context(view_context)` → [void]

Components render in their own view context. Helpers and other functionality
require a reference to the original Rails view context, an instance of
`ActionView::Base`. Use this method to set a reference to the original
view context. Objects that implement this method will render in the component's
view context, while objects that don't will render in the original view context
so helpers, etc work as expected.

## Configuration

### `#config`

Returns the value of attribute config.

### `#current`

Returns the current ViewComponent::Config. This is persisted against this
class so that config options remain accessible before the rest of
ViewComponent has loaded. Defaults to an instance of ViewComponent::Config
with all other documented defaults set.

### `.generate`

The subset of configuration options relating to generators.

All options under this namespace default to `false` unless otherwise
stated.

#### `#path`

Where to put generated components. Defaults to `app/components`:

    config.view_component.generate.path = "lib/components"

#### `#sidecar`

Always generate a component with a sidecar directory:

    config.view_component.generate.sidecar = true

#### `#stimulus_controller`

Always generate a Stimulus controller alongside the component:

    config.view_component.generate.stimulus_controller = true

#### `#typescript`

Generate TypeScript files instead of JavaScript files:

    config.view_component.generate.typescript = true

#### `#locale`

Always generate translations file alongside the component:

    config.view_component.generate.locale = true

#### `#distinct_locale_files`

Always generate as many translations files as available locales:

    config.view_component.generate.distinct_locale_files = true

One file will be generated for each configured `I18n.available_locales`,
falling back to `[:en]` when no `available_locales` is defined.

#### `#preview`

Always generate a preview alongside the component:

     config.view_component.generate.preview = true

#### #preview_path

Path to generate preview:

     config.view_component.generate.preview_path = "test/components/previews"

Required when there is more than one path defined in preview_paths.
Defaults to `""`. If this is blank, the generator will use
`ViewComponent.config.previews.paths` if defined,
`"test/components/previews"` otherwise

#### `#use_component_path_for_rspec_tests`

Whether to use `config.generate.path` when generating new
RSpec component tests:

    config.view_component.generate.use_component_path_for_rspec_tests = true

When set to `true`, the generator will use the `path` to
decide where to generate the new RSpec component test.
For example, if the `path` is
`app/views/components`, then the generator will create a new spec file
in `spec/views/components/` rather than the default `spec/components/`.

### `.instrumentation_enabled`

Whether ActiveSupport notifications are enabled.
Defaults to `false`.

### `.previews`

The subset of configuration options relating to previews.

#### `#controller`

The controller used for previewing components. Defaults to `ViewComponentsController`:

    config.view_component.previews.controller = "MyPreviewController"

#### `#route`

The entry route for component previews. Defaults to `/rails/view_components`:

    config.view_component.previews.route = "/my_previews"

#### `#enabled`

Whether component previews are enabled. Defaults to `true` in development and test environments:

    config.view_component.previews.enabled = false

#### `#default_layout`

A custom default layout used for the previews index page and individual previews. Defaults to `nil`:

    config.view_component.previews.default_layout = "preview_layout"

## ViewComponent::TestHelpers

### `#render_in_view_context(...)`

Execute the given block in the view context (using `instance_exec`).
Internally sets `page` to be a `Capybara::Node::Simple`, allowing for
Capybara assertions to be used. All arguments are forwarded to the block.

```ruby
render_in_view_context(arg1, arg2: nil) do |arg1, arg2:|
  render(MyComponent.new(arg1, arg2))
end

assert_text("Hello, World!")
```

### `#render_inline(component, **args, &block)` → [Nokogiri::HTML5]

Render a component inline. Internally sets `page` to be a `Capybara::Node::Simple`,
allowing for Capybara assertions to be used:

```ruby
render_inline(MyComponent.new)
assert_text("Hello, World!")
```

### `#render_preview(name, from: __vc_test_helpers_preview_class, params: {})` → [Nokogiri::HTML5]

Render a preview inline. Internally sets `page` to be a `Capybara::Node::Simple`,
allowing for Capybara assertions to be used:

```ruby
render_preview(:default)
assert_text("Hello, World!")
```

Note: `#rendered_preview` expects a preview to be defined with the same class
name as the calling test, but with `Test` replaced with `Preview`:

MyComponentTest -> MyComponentPreview etc.

In RSpec, `Preview` is appended to `described_class`.

### `#rendered_content` → [ActionView::OutputBuffer]

Returns the result of a render_inline call.

### `#rendered_json`

`JSON.parse`-d component output.

```ruby
render_inline(MyJsonComponent.new)
assert_equal(rendered_json["hello"], "world")
```

### `#vc_test_controller` → [ActionController::Base]

Access the controller used by `render_inline`:

```ruby
test "logged out user sees login link" do
  vc_test_controller.expects(:logged_in?).at_least_once.returns(false)
  render_inline(LoginComponent.new)
  assert_selector("[aria-label='You must be signed in']")
end
```

### `#vc_test_controller_class`

Set the controller used by `render_inline`:

```ruby
def vc_test_controller_class
  MyTestController
end
```

### `#vc_test_request` → [ActionDispatch::TestRequest]

Access the request used by `render_inline`:

```ruby
test "component does not render in Firefox" do
  request.env["HTTP_USER_AGENT"] = "Mozilla/5.0"
  render_inline(NoFirefoxComponent.new)
  refute_component_rendered
end
```

### `#with_controller_class(klass)`

Set the controller to be used while executing the given block,
allowing access to controller-specific methods:

```ruby
with_controller_class(UsersController) do
  render_inline(MyComponent.new)
end
```

### `#with_format(*formats)`

Set format of the current request

```ruby
with_format(:json) do
  render_inline(MyComponent.new)
end
```

### `#with_request_url(full_path, host: nil, method: nil)`

Set the URL of the current request (such as when using request-dependent path helpers):

```ruby
with_request_url("/users/42") do
  render_inline(MyComponent.new)
end
```

To use a specific host, pass the host param:

```ruby
with_request_url("/users/42", host: "app.example.com") do
  render_inline(MyComponent.new)
end
```

To specify a request method, pass the method param:

```ruby
with_request_url("/users/42", method: "POST") do
  render_inline(MyComponent.new)
end
```

### `#with_variant(*variants)`

Set the Action Pack request variant for the given block:

```ruby
with_variant(:phone) do
  render_inline(MyComponent.new)
end
```

## Errors

### `AlreadyDefinedPolymorphicSlotSetterError`

A method called 'SETTER_METHOD_NAME' already exists and would be overwritten by the 'SETTER_NAME' polymorphic slot setter.

Please choose a different setter name.

### `ContentAlreadySetForPolymorphicSlotError`

Content for slot SLOT_NAME has already been provided.

### `ContentSlotNameError`

COMPONENT declares a slot named content, which is a reserved word in ViewComponent.

Content passed to a ViewComponent as a block is captured and assigned to the `content` accessor without having to create an explicit slot.

To fix this issue, either use the `content` accessor directly or choose a different slot name.

### `ControllerCalledBeforeRenderError`

`#controller` can't be used before rendering, as it depends on the view context that only exists once a ViewComponent is passed to the Rails render pipeline.

It's sometimes possible to fix this issue by moving code dependent on `#controller` to a [`#before_render` method](https://viewcomponent.org/api.html#before_render--void).

### `DuplicateContentError`

It looks like a block was provided after calling `with_content` on COMPONENT, which means that ViewComponent doesn't know which content to use.

To fix this issue, use either `with_content` or a block.

### `DuplicateSlotContentError`

It looks like a block was provided after calling `with_content` on COMPONENT, which means that ViewComponent doesn't know which content to use.

To fix this issue, use either `with_content` or a block.

### `HelpersCalledBeforeRenderError`

`#helpers` can't be used before rendering as it depends on the view context that only exists once a ViewComponent is passed to the Rails render pipeline.

It's sometimes possible to fix this issue by moving code dependent on `#helpers` to a [`#before_render` method](https://viewcomponent.org/api.html#before_render--void).

### `InvalidCollectionArgumentError`

The value of the first argument passed to `with_collection` isn't a valid collection. Make sure it responds to `to_ary`.

### `InvalidSlotDefinitionError`

Invalid slot definition. Please pass a class, string, or callable (that is proc, lambda, etc)

### `MissingCollectionArgumentError`

The initializer for COMPONENT doesn't accept the parameter `PARAMETER`, which is required to render it as a collection.

To fix this issue, update the initializer to accept `PARAMETER`.

See [the collections docs](https://viewcomponent.org/guide/collections.html) for more information on rendering collections.

### `MissingPreviewTemplateError`

A preview template for example EXAMPLE doesn't exist.

To fix this issue, create a template for the example.

### `MissingTemplateError`

No templates for COMPONENT match the request DETAIL.

To fix this issue, provide a suitable template.

### `MultipleInlineTemplatesError`

Inline templates can only be defined once per-component.

### `NilWithContentError`

No content provided to `#with_content` for ViewComponent::NilWithContentError.

To fix this issue, pass a value.

### `RedefinedSlotError`

COMPONENT declares the SLOT_NAME slot multiple times.

To fix this issue, choose a different slot name.

### `ReservedParameterError`

COMPONENT initializer can't accept the parameter `PARAMETER`, as it will override a public ViewComponent method. To fix this issue, rename the parameter.

### `ReservedPluralSlotNameError`

COMPONENT declares a slot named SLOT_NAME, which is a reserved word in the ViewComponent framework.

To fix this issue, choose a different name.

### `ReservedSingularSlotNameError`

COMPONENT declares a slot named SLOT_NAME, which is a reserved word in the ViewComponent framework.

To fix this issue, choose a different name.

### `SlotPredicateNameError`

COMPONENT declares a slot named SLOT_NAME, which ends with a question mark.

This isn't allowed because the ViewComponent framework already provides predicate methods ending in `?`.

To fix this issue, choose a different name.

### `SystemTestControllerNefariousPathError`

ViewComponent SystemTest controller attempted to load a file outside of the expected directory.

### `TranslateCalledBeforeRenderError`

`#translate` can't be used before rendering as it depends on the view context that only exists once a ViewComponent is passed to the Rails render pipeline.

It's sometimes possible to fix this issue by moving code dependent on `#translate` to a [`#before_render` method](https://viewcomponent.org/api.html#before_render--void).

### `UncountableSlotNameError`

COMPONENT declares a slot named SLOT_NAME, which is an uncountable word

To fix this issue, choose a different name.
