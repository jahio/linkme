class LinksController < ApplicationController

  #
  # This controller doesn't need the full gamut of traditional REST resources given
  # the trivial problem domain for this app, so we only have two here: create and show.
  # The form will be rendered on the client-side front-end (likely a Vue.js app or
  # similar) and will ship up a POST with a JSON body. Assuming that passes muster
  # it's used to create a valid URL object and we'll hand that representation to
  # the front-end which will then redirect the user to it or display a link for
  # the user to click, whatever their preference.
  #

  #
  # Create: Take a payload, create the resource, give the created JSON to the user.
  # No redirects to the client in this case, that's up to the front-end.
  #
  def create
    @link = Link.new(link_params)
    if @link.valid?
      @link.save
      render json: @link.to_json
    else
      render json: @link.errors.to_json, status: 400
    end
    # TODO: Implement client IP logging; this is a bit of a chore due to availability of
    # X-Forwarded-For headers from load balancers, etc. being potentially part of the
    # confusion, VPNs in use on the other end, etc. Not a perfect solution by any means...
  end

  #
  # This isn't really a "show" action in the traditional sense, given that it's
  # really just here to render some JSON to the client which will then use it
  # to render a redirect on the front-end. But to follow close-ish to REST
  # semantics, I'm gonna go ahead and call it that. Good 'nuff.
  #
  def show
  end

private

  def link_params
    params.require(:link).permit(:url)
  end

end
